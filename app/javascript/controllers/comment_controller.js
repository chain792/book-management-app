import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["view", "form", "body", "input"]

  edit() {
    this.dispatch("edit-started")

    this.inputTarget.value = this.bodyTarget.textContent.trim()

    this.viewTarget.classList.add("hidden")
    this.formTarget.classList.remove("hidden")
  }

// 他のコメントが「edit-started」を発信したときに実行される
  closeUnlessSelf(event) {
    // イベントの発信元が自分自身（this.element）でない場合のみ閉じる
    if (event.target !== this.element) {
      this.cancel()
    }
  }

  cancel() {
    this.viewTarget.classList.remove("hidden")
    this.formTarget.classList.add("hidden")
  }

  afterSubmit(event) {
    console.log(event)
  }
}
