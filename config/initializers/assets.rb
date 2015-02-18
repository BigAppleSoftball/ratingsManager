# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( isotope.pkgd.js )
Rails.application.config.assets.precompile += %w( sponsorsList.js )
Rails.application.config.assets.precompile += %w( sponsorsList.css )
Rails.application.config.assets.precompile += %w( hofsList.css )
Rails.application.config.assets.precompile += %w( boardList.css )
Rails.application.config.assets.precompile += %w( sponsorCarousel.css )
Rails.application.config.assets.precompile += %w( sponsorsCarousel.js )
Rails.application.config.assets.precompile += %w( sidebar.css )

Rails.application.config.assets.precompile += %w( fieldsMap.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
