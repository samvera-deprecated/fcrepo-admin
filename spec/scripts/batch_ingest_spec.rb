require 'spec_helper'
require 'fileutils'
require "#{Rails.root}/spec/scripts/batch_ingest_spec_helper"

RSpec.configure do |c|
  c.include BatchIngestSpecHelper
end

module DulHydra::Scripts
  
  describe BatchIngest do
    before do
      @ingest_base = setup_test_temp_dir
    end
    after do
      remove_temp_dir
    end
    describe "prepare for ingest" do
      before do
        @manifest_file = "#{@ingest_base}/manifests/item_manifest.yaml"
        update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/item/"})
      end
      it "should expand the consolidated file into appropriate individual files" do
        DulHydra::Scripts::BatchIngest.prep_for_ingest(@manifest_file)
        result_1 = File.open("#{@ingest_base}/item/contentdm/test010010010.xml") { |f| Nokogiri::XML(f) }
        result_2 = File.open("#{@ingest_base}/item/contentdm/test010010020.xml") { |f| Nokogiri::XML(f) }
        result_3 = File.open("#{@ingest_base}/item/contentdm/test010010030.xml") { |f| Nokogiri::XML(f) }
        expected_1 = Nokogiri::XML("<record><Title>Title 1</Title><Date>1981-01</Date><localid>test010010010</localid></record>")
        expected_2 = Nokogiri::XML("<record><Title>Title 2</Title><Date>1987-09</Date><localid>test010010020</localid></record>")
        expected_3 = Nokogiri::XML("<record><Title>Title 3</Title><Date>1979-11</Date><localid>test010010030</localid></record>")
        result_1.should be_equivalent_to(expected_1)
        result_2.should be_equivalent_to(expected_2)
        result_3.should be_equivalent_to(expected_3)        
      end
      it "should create an appropriate master file" do
          DulHydra::Scripts::BatchIngest.prep_for_ingest(@manifest_file)
          result = File.open("#{@ingest_base}/item/master/master.xml") { |f| Nokogiri::XML(f) }
          expected = File.open("spec/fixtures/batch_ingest/results/item_master.xml") { |f| Nokogiri::XML(f) }
          result.should be_equivalent_to(expected)
      end
      it "should create appropriate qualified Dublin Core files" do
        DulHydra::Scripts::BatchIngest.prep_for_ingest(@manifest_file)
        for qdc_filename in qdc_filenames(@manifest_file)
          result = File.open("#{@ingest_base}/item/qdc/#{qdc_filename}") { |f| Nokogiri::XML(f) }
          expected = File.open("spec/fixtures/batch_ingest/results/qdc/#{qdc_filename}") { |f| Nokogiri::XML(f) }
          result.should be_equivalent_to(expected)
        end
      end
    end
    describe "ingest" do
      before do
        @adminPolicy = AdminPolicy.new(pid: 'duke-apo:adminPolicy', label: 'Public Read')
        @adminPolicy.default_permissions = [DulHydra::Permissions::PUBLIC_READ_ACCESS,
                                            DulHydra::Permissions::READER_GROUP_ACCESS,
                                            DulHydra::Permissions::EDITOR_GROUP_ACCESS,
                                            DulHydra::Permissions::ADMIN_GROUP_ACCESS]
        @adminPolicy.permissions = AdminPolicy::APO_PERMISSIONS
        @adminPolicy.save!
      end
      after do
        @adminPolicy.delete
      end
      context "applicable to all object types" do
        before do
          FileUtils.cp "spec/fixtures/batch_ingest/results/item_master.xml", "#{@ingest_base}/item/master/master.xml"
          FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/item_1.xml", "#{@ingest_base}/item/qdc"
          FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/item_2.xml", "#{@ingest_base}/item/qdc"
          FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/item_4.xml", "#{@ingest_base}/item/qdc"
          @pre_existing_item_pids = []
          Item.find_each { |i| @pre_existing_item_pids << i.pid }
          @manifest_file = "#{@ingest_base}/manifests/item_manifest.yaml"
          update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/item/"})
          @ingested_identifiers = [ [ "item_1" ], [ "item_2", "item_3" ], [ "item_4" ] ]          
          @collection = Collection.new(:pid => "test:collection1")
          @collection.identifier = "collection_1"
          @collection.save!
        end
        after do
          Item.find_each do |i|
            if !@pre_existing_item_pids.include?(i.pid)
              i.delete
            end
          end
        end
        it "should create an appropriate object in the repository" do
          DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
          items = []
          Item.find_each do |i|
            if !@pre_existing_item_pids.include?(i.pid)
              items << i
            end
          end
          items.should have(3).things
          items.each do |item|
            item.admin_policy.should == @adminPolicy
            @ingested_identifiers.should include(item.identifier)
            case item.identifier
            when [ "item_1" ]
              item.label.should == "Manifest Label"
            when [ "item_2", "item_3" ]
              item.label.should == "Second Object Label"
            when [ "item_4" ]
              item.label.should == "Manifest Label"
            end
          end
        end
        it "should update the master file with the ingested PIDs" do
          DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
          master = File.open("#{@ingest_base}/item/master/master.xml") { |f| Nokogiri::XML(f) }
          master.xpath("/objects/object").each do |object|
            identifier = object.xpath("identifier").first.content
            object.xpath("pid").should_not be_empty
            pid = object.xpath("pid").first.content
            repo_object = Item.find(pid)
            repo_object.identifier.should include(identifier)
          end
        end
        it "should add a descMetadata datastream" do
          DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
          master = File.open("#{@ingest_base}/item/master/master.xml") { |f| Nokogiri::XML(f) }
          master.xpath("/objects/object").each do |object|
            identifier = object.xpath("identifier").first.content
            pid = object.xpath("pid").first.content
            item = Item.find(pid)
            item.datastreams.keys.should include("descMetadata")
            item.descMetadata.label.should == "Descriptive Metadata for this object"
            content_xml = item.descMetadata.content { |f| Nokogiri::XML(f) }
            expected_xml = Nokogiri::XML(File.open("#{@ingest_base}/item/qdc/#{identifier}.xml"))
            content_xml.should be_equivalent_to(expected_xml)
          end
        end
      end
      context "digitization guide to be ingested" do
        context "digitization guide is in canonical location and is named in manifest" do
          before do
            FileUtils.cp "spec/fixtures/batch_ingest/results/collection_master.xml", "#{@ingest_base}/collection/master/master.xml"
            FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/collection_1.xml", "#{@ingest_base}/collection/qdc/"
            @pre_existing_collection_pids = []
            Collection.find_each { |c| @pre_existing_collection_pids << c.pid }
            @manifest_file = "#{@ingest_base}/manifests/collection_manifest.yaml"
            update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/collection/"})
            @ingested_identifiers = [ [ "collection_1" ] ]
            @expected_content_size = File.open("#{@ingest_base}/collection/digitizationguide/DigitizationGuide.xls") { |f| f.size }
          end
          after do
            Collection.find_each do |c|
              if !@pre_existing_collection_pids.include?(c.pid)
                c.delete
              end
            end
          end
          it "should add a digitizationGuide datastream containing the named file" do
            DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
            collections = []
            Collection.find_each do |c|
              if !@pre_existing_collection_pids.include?(c.pid)
                collections << c
              end
            end
            collections.each do |collection|
              if collection.identifier == [ "collection_1" ]
                collection.datastreams.keys.should include("digitizationGuide")
                collection.digitizationGuide.label.should == "Digitization Guide Data for this object"
                content = collection.datastreams["digitizationGuide"].content
                content.size.should == @expected_content_size
              end
            end
          end
        end
      end
      context "FileMaker Pro export to be ingested" do
        context "FMP export is in canonical location and is named in manifest" do
          before do
            FileUtils.cp "spec/fixtures/batch_ingest/results/collection_master.xml", "#{@ingest_base}/collection/master/master.xml"
            FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/collection_1.xml", "#{@ingest_base}/collection/qdc/"
            @pre_existing_collection_pids = []
            Collection.find_each { |c| @pre_existing_collection_pids << c.pid }
            @manifest_file = "#{@ingest_base}/manifests/collection_manifest.yaml"
            update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/collection/"})
            @ingested_identifiers = [ [ "collection_1" ] ]
            @expected_content_size = File.open("#{@ingest_base}/collection/fmpexport/dpc_structural_metadata_vica.xls") { |f| f.size }
          end
          after do
            Collection.find_each do |c|
              if !@pre_existing_collection_pids.include?(c.pid)
                c.delete
              end
            end
          end
          it "should add a fmpExport datastream containing the named file" do
            DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
            collections = []
            Collection.find_each do |c|
              if !@pre_existing_collection_pids.include?(c.pid)
                collections << c
              end
            end
            collections.each do |collection|
              if collection.identifier == [ "collection_1" ]
                collection.datastreams.keys.should include("fmpExport")
                collection.fmpExport.label.should == "FileMakerPro Export Data for this object"
                content = collection.datastreams["fmpExport"].content
                content.size.should == @expected_content_size
              end
            end
          end
        end
      end
      context "Marc XML to be ingested" do
        context "Marc XML is in canonical location and is named in manifest" do
          before do
            FileUtils.cp "spec/fixtures/batch_ingest/results/collection_master.xml", "#{@ingest_base}/collection/master/master.xml"
            FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/collection_1.xml", "#{@ingest_base}/collection/qdc/"
            @pre_existing_collection_pids = []
            Collection.find_each { |c| @pre_existing_collection_pids << c.pid }
            @manifest_file = "#{@ingest_base}/manifests/collection_manifest.yaml"
            update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/collection/"})
            @ingested_identifiers = [ [ "collection_1" ] ]
            @expected_content_size = File.open("#{@ingest_base}/collection/marcxml/marcxml.xml") { |f| f.size }
          end
          after do
            Collection.find_each do |c|
              if !@pre_existing_collection_pids.include?(c.pid)
                c.delete
              end
            end
          end
          it "should add a marcXML datastream containing the named file" do
            DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
            collections = []
            Collection.find_each do |c|
              if !@pre_existing_collection_pids.include?(c.pid)
                collections << c
              end
            end
            collections.each do |collection|
              if collection.identifier == [ "collection_1" ]
                collection.datastreams.keys.should include("marcXML")
                collection.marcXML.label.should == "Aleph MarcXML Data for this object"
                content = collection.datastreams["marcXML"].content
                content.size.should == @expected_content_size
              end
            end
          end
        end
      end
      context "content to be ingested" do
        before do
          FileUtils.cp "spec/fixtures/batch_ingest/results/component_master.xml", "#{@ingest_base}/component/master/master.xml"
          FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/CCITT_2.xml", "#{@ingest_base}/component/qdc/"
          FileUtils.cp "spec/fixtures/batch_ingest/samples/CCITT_2.TIF", "#{@ingest_base}/component/content/"
          @pre_existing_component_pids = []
          Component.find_each { |c| @pre_existing_component_pids << c.pid }
          @manifest_file = "#{@ingest_base}/manifests/component_manifest.yaml"
          update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/component/"})
          @ingested_identifiers = [ [ "CCITT_2" ] ]
          @expected_content = File.open("spec/fixtures/batch_ingest/samples/CCITT_2.TIF", "rb")
        end
        after do
          @expected_content.close
          Component.find_each do |c|
            if !@pre_existing_component_pids.include?(c.pid)
              c.delete
            end
          end
        end
        it "should add a content datastream containing the content file" do
          DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
          components = []
          Component.find_each do |c|
            if !@pre_existing_component_pids.include?(c.pid)
              components << c
            end
          end
          components.each do |component|
            if component.identifier == [ "CCITT_2" ]
              component.content.label.should == "Content file for this object"
              content = component.datastreams["content"].content
              FileUtils.compare_stream(StringIO.new(content, "rb"), @expected_content)
            end
          end
        end
      end
      context "object has parent object" do
        context "child is part of parent" do
          context "parent identifier is determined algorithmically" do
            before do
              FileUtils.cp "spec/fixtures/batch_ingest/results/component_master.xml", "#{@ingest_base}/component/master/master.xml"
              FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/CCITT_2.xml", "#{@ingest_base}/component/qdc/"
              FileUtils.cp "spec/fixtures/batch_ingest/samples/CCITT_2.TIF", "#{@ingest_base}/component/content/"
              @pre_existing_component_pids = []
              Component.find_each { |c| @pre_existing_component_pids << c.pid }
              @manifest_file = "#{@ingest_base}/manifests/component_manifest.yaml"
              update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/component/"})
              update_manifest(@manifest_file, {"autoparentidlength" => 5})
              @item = Item.new(:pid => "test:item1")
              @item.identifier = "CCITT"
              @item.save!
            end
            after do
              Component.find_each do |c|
                if !@pre_existing_component_pids.include?(c.pid)
                  c.delete
                end
              end
              @item.delete
            end
            it "should establish an 'isPartOf' relationship between the child and parent" do
              DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
              components = []
              Component.find_each do |c|
                if !@pre_existing_component_pids.include?(c.pid)
                  components << c
                end
              end
              components.each do |component|
                component.container.should eq(@item)
                @item.parts.should include(component)
              end
            end
          end
        end
        context "child is member of parent" do
          context "parent identifier is specified is manifest" do
            before do
              FileUtils.cp "spec/fixtures/batch_ingest/results/item_master.xml", "#{@ingest_base}/item/master/master.xml"
              FileUtils.cp "spec/fixtures/batch_ingest/results/collection_master_with_pid.xml", "#{@ingest_base}/collection/master/master.xml"
              FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/item_1.xml", "#{@ingest_base}/item/qdc"
              FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/item_2.xml", "#{@ingest_base}/item/qdc"
              FileUtils.cp "spec/fixtures/batch_ingest/results/qdc/item_4.xml", "#{@ingest_base}/item/qdc"
              FileUtils.cp "spec/fixtures/batch_ingest/BASE/item/tripodmets/item1.xml", "#{@ingest_base}/item/tripodmets"
              FileUtils.cp "spec/fixtures/batch_ingest/BASE/item/tripodmets/item2.xml", "#{@ingest_base}/item/tripodmets"
              FileUtils.cp "spec/fixtures/batch_ingest/BASE/item/tripodmets/item4.xml", "#{@ingest_base}/item/tripodmets"
              @pre_existing_item_pids = []
              Item.find_each { |i| @pre_existing_item_pids << i.pid }
              @manifest_file = "#{@ingest_base}/manifests/item_manifest.yaml"
              update_manifest(@manifest_file, {"basepath" => "#{@ingest_base}/item/"})
              @collection = Collection.new(:pid => "test:collection1")
              @collection.identifier = "collection_1"
              @collection.save!
            end
            after do
              Item.find_each do |i|
                if !@pre_existing_item_pids.include?(i.pid)
                  i.delete
                end
              end
              @collection.delete
            end
            it "should establish an 'isMemberOf' relationship between the child and parent" do
              DulHydra::Scripts::BatchIngest.ingest(@manifest_file)
              items = []
              Item.find_each do |i|
                if !@pre_existing_item_pids.include?(i.pid)
                  items << i
                end
              end
              items.each do |item|
                item.collection.should eq(@collection)
                @collection.items.should include(item)
              end
            end
          end
        end
      end
    end
  end
  
end