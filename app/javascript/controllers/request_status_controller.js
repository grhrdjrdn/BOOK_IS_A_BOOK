import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"
window.Swal = Swal
// Connects to data-controller="request-status"
export default class extends Controller {

  connect() {
    console.log("Request Status Controller is Working!")
  }

  deny(event) {

    console.log("send invoked")
    const action = event.params.action
    const path = event.params.path
    const target = event.target.parentElement.parentElement.querySelector(".status")
    const book_id = event.target.parentElement.parentElement.dataset.bookId
    console.log(action)
    console.log(path)
    console.log(target)

    const csrfToken = document.querySelector("[name='csrf-token']").content

    Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning", showCancelButton: true,
      confirmButtonText: "Yes"
      }).then((result) => {
        console.log(result)
      if (result.isConfirmed) {
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
              book.querySelector(".status").innerText = "Just swapped!"
              document.querySelector(".previous-books").prepend(book)
            }
          })
      } else if (result.isDismissed) {
        // Handle the case where the user dismisses the alert console.log("User canceled the action!");
      }
    });

    }

  approve(event) {

      console.log("send invoked")
      const action = event.params.action
      const path = event.params.path
      const target = event.target.parentElement.parentElement.querySelector(".status")
      const book_id = event.target.parentElement.parentElement.dataset.bookId
      console.log(action)
      console.log(path)
      console.log(target)

      const csrfToken = document.querySelector("[name='csrf-token']").content

      Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "info", showCancelButton: true,
        confirmButtonText: "Yes"
        }).then((result) => {
          console.log(result)
        if (result.isConfirmed) {
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
              const book = document.querySelector(`.book[data-book-id='${book_id}']`)
              book.querySelector(".caption").innerText = "Just swapped!"
              document.querySelector(".previous-books").prepend(book)
            }
          })
        } else if (result.isDismissed) {
          // Handle the case where the user dismisses the alert console.log("User canceled the action!");
        }
      });

    }
}
