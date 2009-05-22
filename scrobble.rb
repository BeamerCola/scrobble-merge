require 'rubygems'
require 'sinatra'
require 'scrobbler'

get "/fetch/*" do
  @tracks = []
  for user in params[:splat].first.split("/")
    user = Scrobbler::User.new(user)
    for track in user.recent_tracks
      @tracks << {:user => user.username, :track => track}
    end
  end
  @tracks = @tracks.sort{ |x,y| x[:track].date <=> y[:track].date }.flatten.reverse
  erb :index
end

use_in_file_templates!
__END__

@@ index
<ul>
<% for track in @tracks %>
  <li><%= track[:track].name %> &mdash; <%= track[:user] %> &mdash; <%= track[:track].date %></li>
<% end %>
</ul>
