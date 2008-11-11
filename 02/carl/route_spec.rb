describe Router, ".map" do
  before do
    something = Router::Map.new
    router = NewRoutes.draw(something) do |map|
      map.get('/').controller(:pages).action(:home)
    end
  end
  
  it 'should match blah' do
    somthing.should_receive(:connect).with(:controller => 'dog')
  end
end