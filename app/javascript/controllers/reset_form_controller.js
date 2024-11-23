import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-form"
export default class extends Controller {
  connect() {
    console.log("Hello from reset form controller")
  }
  reset() {
    this.element.reset()
  }
}
