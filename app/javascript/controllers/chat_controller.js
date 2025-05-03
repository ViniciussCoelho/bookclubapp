import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["input"]
  
  connect() {
    this.consumer = createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      { channel: "ClubChatChannel", club_id: this.clubId },
      {
        received: data => {
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

  appendMessage({ user, user_email, message, timestamp }) {
    const p = document.createElement("p")
    const time = new Date(timestamp).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })
    p.innerHTML = `${time} <strong>${user_email}:</strong> ${message}`
    this.element.querySelector("#messages").appendChild(p)
  }
}