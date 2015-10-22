

# helpers do # methods defined here are available in the .erb files, actions.rb and templates in the app
  
#   def logged_in?
#     !!current_user
#   end

#   def current_user
#     if session[:user_id]
#       User.find(session[:user_id])
#     end
#   end
# end

helpers do

  def photos(n)
    recent = flickr.photos.getRecent(per_page: n)
      recent.map do |photo|
        info = flickr.photos.getInfo photo_id: photo.id
        FlickRaw.url(info)
      end
  end

end


# Homepage (Root path)
get '/' do
  @photos = photos(1)
  erb :index
end


#will display the top captions based on total votes for the image
get '/top/:id/show' do
  @title = 'Top Captions'
  # @images = Image.all.order(total_votes: :desc)
  @images = Image.by_total_votes.limit(3)
  binding.pry
  erb :'index'
end

#will display the most recent caption
get '/recent/:id/show' do
  @title = 'Most Recent Captions'
  @images = Image.all.order(updated_at: :desc)
  erb :'index'
end

#<form method="post" action="/submit">
# <button class="btn btn-lg btn-primary btn-block" type="submit" value="submit">Capjur it!</button>

#posts a new caption to a new picture or any picture. This caption command should work anywhere.
post '/submit' do
  @caption = Caption.new(
    text: params[:text],
  )
  if @caption.save
    redirect '/'
  else
    erb :'/show'
  end
end


#when image on the front page is clicked, it redirects to its already existing caption page
get '/image/:id' do
  @image = Image.find params[:id]
  erb :'/show'
end



#


  

###########################################################
#As a user I can add a caption to a picture that already has captions
get '/images/:id/show' do

end
# POST: /images/:id/show/save
# Actions: Form text area with a submit action
# Save caption
###########################################################

#A user can choose from a list of random pictures
get '/generate' do
  @photos = photos(1)
  erb :'generate' #Call Flickr API to return # images
end

post '/generate/new' do
  @image = Image.new(url: params[:image])
  @image.save
  erb :'caption'
end

