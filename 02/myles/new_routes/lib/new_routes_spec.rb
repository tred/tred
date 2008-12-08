
# this is too much ceremony
describe "Router with one root mapping" do

  before do 
    @router = NewRouteMapper.new.draw do |map|  
      map.get('/').controller(:pages).action(:home)  
    end
  end

  it "finds route for /" do 
    request = Request.new(:path => '/')
    mock(request).path_params = { :controller => 'pages', :action => 'home' }
    @router.recognize(request).should == PageController
  end

end


# we should do this:
match '/', PageController, { :action => 'home' }