pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "@tailwindplus/elements", to: "https://cdn.jsdelivr.net/npm/@tailwindplus/elements@1/+esm"
pin "alpinejs", to: "https://unpkg.com/alpinejs@3.12.0/dist/module.esm.js"

pin_all_from "app/javascript/controllers", under: "controllers"
