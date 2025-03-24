// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import SearchController from "./search_controller"
application.register("search", SearchController)
import TimeframeController from "./timeframe_controller"
application.register("timeframe", TimeframeController)
import CountrySelectionController from "./country_selection_controller"
application.register("country-selection", CountrySelectionController)
