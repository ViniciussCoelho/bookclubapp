import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.form.addEventListener("turbo:submit-end", () => {
      this.element.value = ""
    })
  }
} 