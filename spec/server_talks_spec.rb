require 'server_talks'

describe ServerTalks do
  specify '.new returns a new class' do
    ServerTalks.build_server.should be_a_kind_of Class
  end

  context ".new takes an initialization block where" do
    specify "methods can be defined for the class's instances" do
      ServerTalks.build_server { def meth() 123 end }.new.meth.should == 123
    end

    specify "class methods can be invoked" do
      slf = nil
      server = ServerTalks.build_server { slf = self }
      server.should equal slf
    end
  end

  describe 'the generated class' do
    context 'when handling a url' do
      it 'invokes blocks for the url' do
        num = 0
        server.url('/') { num = 1 }
        num.should == 0
        server.new('/').result
        num.should == 1
      end

      it 'returns whatever the block returns' do
        server.url('/') { "a" }.new('/').result.should == "a"
      end

      it 'treats :whatever in urls as named params that it parses out' do
        server.url('/a/:b') {}.new('/a/1').params.should_not have_key :a
        server.url('/a/:b') {}.new('/a/1').params[:b].should == '1'
        server.url('/a/:b/') {}.new('/a/1').params[:b].should == '1'
        server.url('/a/:b/:c') {}.new('/a/1/c').params[:b].should == '1'
        server.url('/a/:b/:c') {}.new('/a/1/x').params[:c].should == 'x'
      end

      it 'raises an error if the route cannot be matched' do
        server.url('/a') {}.new('/a')
        expect { server.url('/a') {}.new('/b') }.to raise_error ServerTalks::NoRoute, /\/b/
        expect { server.url('/a') {}.new('/a/b') }.to raise_error ServerTalks::NoRoute, /\/b/
      end

      it 'ignores trailing slashes' do
        server.url('/a') {}.new('/a/')
        server.url('/a/') {}.new('/a')
        server.url('/a/:b/') {}.new('/a/:b')
        server.url('/a/:b') {}.new('/a/:b/')
      end
    end

    describe 'templates' do
      it 'can be registered' do
        server.templates a: 'b', c: 'd'
        server.template_for(:a).should == 'b'
        server.template_for(:c).should == 'd'
      end

      it 'is rendered with erb for the current instance' do
        server.url('/') { @var = "b" }
        server.templates a: 'a<%= @var %>c'
        server.new('/').result.should == 'abc'
      end
    end
  end
end
