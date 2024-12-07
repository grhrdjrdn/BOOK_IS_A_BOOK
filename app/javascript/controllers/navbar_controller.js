import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {

  connect() {
  }

  fire(event) {
    event.target.parentElement.classList.toggle("active");
    const text = event.target.innerText;
    if (text === "MENU") {
      event.target.innerText = "Close";
    } else {
      event.target.innerText = "Menu";
    }
  }

}
