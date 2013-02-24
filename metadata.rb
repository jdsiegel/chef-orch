name             "orch"
maintainer       "Jeff Siegel"
maintainer_email "jdsiegel@gmail.com"
license          "Apache v2.0"
description      "Opinionated configuration for rails/rack apps"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "orch_db"
depends "orch_web"
depends "orch_app"

supports "ubuntu"
