if Article.count == 0
  Article.create!(:title => "The dummy app lives", :body => "If you see this, the app is working.")
end
