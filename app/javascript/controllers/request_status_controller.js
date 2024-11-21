import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="request-status"
export default class extends Controller {
  connect() {
    console.log("Request Status Controller is Working!")
  }

  send(event) {

    console.log("send invoked")
    const action = event.params.action
    const path = event.params.path
    const target = event.target.parentElement.querySelector(".status")
    console.log(action)
    console.log(path)
    console.log(target)

    const csrfToken = document.querySelector("[name='csrf-token']").content

    if (window.confirm("Do you really want to swap?")) {

      fetch(path, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        }
      })
        .then(response => response.json())
        .then((data) => {
          if (data.status) {
            target.innerText = data.status
            target.parentElement.classList = ""
            target.parentElement.classList.add(data.status)
          }
        })

    }
  }
}
