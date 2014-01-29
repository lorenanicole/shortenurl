require 'pry'
enable :sessions

get '/' do
  # let user create new short URL, display a list of shortened URLs
  @new_secret = session[:secret]
  # binding.pry
  @errors =  session[:error]

  @all_urls = Url.all
  # binding.pry
  erb :index
end

post '/urls' do
  temp_url = Url.new(full_url: params[:new], click_counter: 0)
  temp_url.save
  # binding.pry
  if !temp_url.errors.empty?
    session[:error] = temp_url.errors.messages
    session[:secret] = nil
    redirect('/')
  else
    # binding.pry
    session[:secret] = Url.last.shortened_url
    session[:error] = {}
    redirect('/')
  end
  # create a new Url
end

# e.g., /q6bda
get '/:short_url' do
  url = Url.where(shortened_url: params[:short_url]).first
  url.click_counter += 1
  url.save
  # pry.binding
  # puts "#{url.full_url}"
  redirect("#{url.full_url}")
  # redirect to appropriate "long" URL
end
