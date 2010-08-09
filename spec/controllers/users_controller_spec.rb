require File.join(File.dirname(__FILE__), '../spec_helper')

describe UsersController do

  before :all do
  end

  before :each do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(controller)
    @user = Factory(:user)
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      UserSession.find.destroy
      get :new

      assigns[:user].should be_a User
      assigns[:user].should be_new_record
    end
  end

  describe "POST create" do
    before do
      UserSession.find.destroy

      post :create, :user => { :email => "bob@example.com",
                               :password => "magic",
                               :password_confirmation => "magic" }

    end

    describe "with valid params" do
      it "assigns a newly created user as @user" do
        assigns[:user].should be_a User
        assigns[:user].should_not be_new_record
      end

      it "redirects to the created user" do
        response.should redirect_to(root_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, :user => {}
        assigns[:user].should be_a User
        assigns[:user].should be_new_record
      end

      it "re-renders the 'new' template" do
        post :create, :user => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    before do
      UserSession.create @user
    end

    describe "with valid params" do
      it "updates the requested user" do
        put :update, :id => @user.id, :user => {:email => "new@example.com"}
        @user.reload.email.should == "new@example.com"
      end

      it "assigns the requested user as @user" do
        put :update, :id => @user.id, :user => {:email => "new@example.com"}
        assigns[:user].should == @user
      end

      it "redirects to the user" do
        put :update, :id => @user.id, :user => {:email => "new@example.com"}
        response.should redirect_to(my_account_url)
      end
    end
  end
end
