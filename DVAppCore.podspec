Pod::Spec.new do |s|
  s.name         = "DVAppCore"
  s.version      = "0.8.3"
  s.summary      = "Set of useful categories and helpers."
  s.description  = <<-DESC
                    The DVAppCore for iOS provides:
                    * Categories
                    * Views
                    * Templates
                    * Helpers
                    * Models
                    * Controllers
                    DESC
  s.homepage            = 'https://github.com/denis-vashkovski/DVAppCore'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.authors             = { 'Denis Vashkovski' => 'denis.vashkovski.vv@gmail.com' }
  s.platform     = :ios, "9.0"
  s.source       = { :git => 'https://github.com/denis-vashkovski/DVAppCore.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.subspec 'Categories' do |categories|
    categories.ios.source_files = 'DVAppCore/Categories/{AC}*.{h,m}'
    categories.subspec 'NS' do |ns|
      ns.ios.source_files = 'DVAppCore/Categories/{NS}*.{h,m}'
    end
    categories.subspec 'UI' do |ui|
      ui.ios.source_files = 'DVAppCore/Categories/{UI}*.{h,m}'
    end
  end

  s.subspec 'Views' do |views|
    views.subspec 'Models' do |models|
      models.ios.source_files = 'DVAppCore/Views/Models/*.{h,m}'
    end
    views.subspec 'Protocols' do |protocols|
      protocols.ios.source_files = 'DVAppCore/Views/Protocols/*.{h,m}'
    end
    views.subspec 'DesignableView' do |dv|
      dv.ios.source_files = 'DVAppCore/Views/DesignableView/*.{h,m}'
    end
    views.ios.source_files = 'DVAppCore/Views/*.{h,m}'
  end

  s.subspec 'Models' do |models|
    models.ios.source_files = 'DVAppCore/Models/*.{h,m}'
    models.dependency 'DVAppCore/Categories'
  end

  s.subspec 'Helpers' do |helpers|
    helpers.subspec 'Contacts' do |contacts|
      contacts.ios.source_files = 'DVAppCore/Helpers/ACContactsHelper.{h,m}'
    end
    helpers.subspec 'DataKeeper' do |dataKeeper|
      dataKeeper.ios.source_files = 'DVAppCore/Helpers/ACDataKeeper.{h,m}'
    end
    helpers.subspec 'Design' do |design|
      design.ios.source_files = 'DVAppCore/Helpers/ACDesignHelper.{h,m}'
    end
    helpers.subspec 'ImagePicker' do |imagePicker|
      imagePicker.ios.source_files = 'DVAppCore/Helpers/ACImagePicker.{h,m}'
    end
    helpers.subspec 'Logging' do |logging|
      logging.ios.source_files = 'DVAppCore/Helpers/ACLog.{h,m}'
    end
    helpers.subspec 'Operation' do |operation|
      operation.ios.source_files = 'DVAppCore/Helpers/ACPendingOperations.{h,m}', 'DVAppCore/Helpers/ACAsynchronousOperation.{h,m}', 'DVAppCore/Helpers/ACAsyncBlockOperation.{h,m}'
    end
    helpers.subspec 'Router' do |router|
      router.ios.source_files = 'DVAppCore/Helpers/ACRouter.{h,m}'
    end
    helpers.subspec 'Location' do |location|
      location.ios.source_files = 'DVAppCore/Helpers/ACLocationHelper.{h,m}'
    end
    helpers.subspec 'Localization' do |localization|
      localization.ios.source_files = 'DVAppCore/Helpers/ACLocalizationHelper.{h,m}'
    end
    helpers.subspec 'URLConnection' do |urlConnection|
      urlConnection.ios.source_files = 'DVAppCore/Helpers/{ACURLConnection}*.{h,m}'
    end
    helpers.ios.source_files = 'DVAppCore/Helpers/ACConstants.h'
    helpers.dependency 'DVAppCore/Models'
  end

  s.subspec 'Templates' do |templates|
    templates.subspec 'Extended' do |extended|
      extended.ios.source_files = 'DVAppCore/Templates/Extended/*.{h,m}'
    end
    templates.ios.source_files = 'DVAppCore/Templates/*.{h,m}'
    templates.dependency 'DVAppCore/Helpers'
  end

  s.subspec 'Controllers' do |controllers|
   controllers.ios.source_files = 'DVAppCore/Controllers/*.{h,m}'
   controllers.dependency 'DVAppCore/Categories'
  end

  s.ios.source_files = 'DVAppCore/DVAppCore.{h,m}'
  s.resources = 'DVAppCore/ACAssets.xcassets'
end
