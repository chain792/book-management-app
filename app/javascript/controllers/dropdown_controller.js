import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  // メニューの表示/非表示を切り替える
  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  // メニューの外側をクリックした時に閉じる（オプション）
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
