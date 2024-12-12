import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"
window.Swal = Swal
// Connects to data-controller="alert"
export default class extends Controller {
  static values = {
    icon: String,
    alertTitle: String,
    alertHtml: String,
    confirmButtonText: String,
    showCancelButton: Boolean,
    cancelButtonText: String
  }

  connect() {
    console.log("Sweet alert connected!");
  }

  initSweetalert(event) {
    event.preventDefault(); // Prevent the form to be submited after the submit button has been clicked

    Swal.fire({
      icon: "warning",
      title: "Are your sure?",
      html: "Create new post.",
      confirmButtonText: "All good!",
      showCancelButton: true,
      cancelButtonText: "Cancel",
      reverseButtons: true
    })
  }
}
