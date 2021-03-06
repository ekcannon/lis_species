require 'spec_helper'

describe VigraContentsController do

  def mock_vigra_content(stubs={})
    @mock_vigra_content ||= mock_model(VigraContent, stubs).as_null_object
  end

  before(:each) { create_roles }

  describe "GET index without logging in" do
    before(:each) do
      @vigra = FactoryGirl.build(:vigra_content)
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
  end

  describe "GET index while logged in as superuser" do
    login_superuser
    it "should get index and set ckfinder_role cookie" do
      get :index
      response.should be_success
    end
  end

  describe "GET index while logged in as admin" do
    login_admin
    it "should get index and set ckfinder_role cookie" do
      get :index
      response.should be_success
    end
  end

  describe "GET index while logged in as editor" do
    login_editor
    it "should get index and set ckfinder_role cookie" do
      get :index
      response.should be_success
    end
  end

  describe "GET index while logged in as system_user" do
    login_system_user
    it "should get index and set ckfinder_role cookie" do
      get :index
      response.should be_success
    end
  end

  after(:all) { destroy_roles }

end
