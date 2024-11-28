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
    const target = event.target.parentElement.parentElement.querySelector(".status")
    const book_id = event.target.parentElement.parentElement.dataset.bookId
    console.log(action)
    console.log(path)
    console.log(target)

    const csrfToken = document.querySelector("[name='csrf-token']").content

    if (window.confirm("Are you sure?")) {

      fetch(path, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        }
      }).then(response => response.json())
        .then((data) => {
          if (data.status == "denied") {
            target.innerText = data.status
            target.parentElement.classList.remove("pending")
            target.parentElement.classList.add(data.status)
          } else {
            target.innerText = "Just swapped"
            const book = document.querySelector(`.book_item[data-book-id='${book_id}']`)
            document.querySelector(".previous-books").prepend(book)
          }
        })

    }
  }
}
