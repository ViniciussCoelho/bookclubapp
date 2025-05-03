import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["input"]
  
  connect() {
    console.log("Chat controller connected")
    console.log("Club ID:", this.clubId)

    this.consumer = createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      { channel: "ClubChatChannel", club_id: this.clubId },
      {
        connected: () => console.log("Connected to chat channel"),
        disconnected: () => console.log("Disconnected from chat channel"),
        received: data => {
          console.log("Received data:", data)
          this.appendMessage(data)
        }
      }
    )
  }

  get clubId() {
    return this.element.dataset.chatClubId
  }

  send(event) {
    event.preventDefault()
    const message = this.inputTarget.value
    if (message.trim() === "") return

    this.subscription.send({ message })
    this.inputTarget.value = ""
  }

  appendMessage({ user, message, timestamp }) {
    const p = document.createElement("p")
    const time = new Date(timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    p.innerHTML = `<strong>${user}</strong> <em>${time}</em>: ${message}`
    this.element.querySelector("#messages").appendChild(p)
  }
}