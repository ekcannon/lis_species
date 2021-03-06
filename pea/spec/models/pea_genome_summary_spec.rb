require 'spec_helper'

describe PeaGenomeSummary do
  it "has zero records" do
    PeaGenomeSummary.count.should == 0
  end

  it "has one record" do
    FactoryGirl.create(:pea_genome_summary)
    PeaGenomeSummary.count.should == 1
  end

  it "removes % after self.gc_content_genome" do
    ags = PeaContent.new.build_pea_genome_summary({
      :pea_content_id => 1,
      :gc_content_genome => '22.5%'
    })
    ags.save
    ags.gc_content_genome.should == '22.5'
  end

  it "removes % after self.gc_content_transcriptome" do
    ags = PeaContent.new.build_pea_genome_summary({
      :pea_content_id => 1,
      :gc_content_transcriptome => '78%'
    })
    ags.save
    ags.gc_content_transcriptome.should == '78'
  end
end
