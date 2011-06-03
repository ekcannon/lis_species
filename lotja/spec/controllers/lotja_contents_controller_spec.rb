require 'spec_helper'

describe LotjaContentsController do
  
  def mock_lotja_content(stubs={})
    @mock_lotja_content ||= mock_model(LotjaContent, stubs).as_null_object
  end

  before(:all) do
    create_roles
  end
  
  describe "GET index without logging in" do
    before(:each) do
      @lotja = Factory.build(:lotja_content)
    end
    it "should get index" do
      get :index
      response.should be_success
    end
  end
  
  describe "access restricted without logging in" do
    it "edit/:id should redirect" do
      get :edit, :id => "10"
      response.should be_redirect
    end
    it "update/:id should redirect" do
      put :update, :id => "10", :news_article => {}
      response.should be_redirect
    end
    it "/:id/send_data_file should redirect" do
      get :send_data_file, :id => "31"
      response.should be_redirect
    end
  end
  
  describe "GET edit and PUT update lotja_content while logged in as superuser" do
    login_superuser
    before(:each) do
      @lotja = Factory.build(:lotja_content)
      LotjaContent.should_receive(:find).with("21").and_return(@lotja)
    end
    it "should find lotja_content and return object" do
      get :edit, :id => "21"
      response.should render_template('edit')
    end
    it "should update object" do
      put :update, :id => "21", :lotja_content => {}, :lotja_selected_reference => {},
        :lotja_genome_summary => {}, :lotja_resource => {}
      response.should be_redirect
    end
  end
  
  describe "GET send_data_file as superuser" do
    login_superuser
    before(:each) do
      @lotja = Factory.build(:lotja_content)
      LotjaContent.should_receive(:find).with("43").and_return(@lotja)
      @lotja.should_receive(:file_name).and_return("")
      controller.should_receive(:send_file)
      controller.stub!(:render)
    end
    it "should send data file" do
      get :send_data_file, :id => "43"
      response.should be_success
    end
  end
  
  after(:all) do
    destroy_roles  
  end
  
end