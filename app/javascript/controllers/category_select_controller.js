import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["childContainer", "submitButton"]
  static values = { categories: Array }

  change(event) {
    const parentId = event.target.value
    const childCategory = document.getElementById('child_category')

    // 大カテゴリが未選択の場合
    if (!parentId) {
      if (childCategory) childCategory.remove()
      this.toggleButton(false)
      return
    }

    // 子カテゴリのSelect要素を生成
    const select = document.createElement("select")
    select.id = 'child_category'
    select.name = 'book[child_category]'
    select.classList.add('w-full', 'rounded-md', 'border', 'border-gray-300', 'px-3', 'py-2', 'text-sm', 'focus:border-blue-500')
    
    select.add(new Option('小カテゴリを選択', ''))
    
    // データのフィルタリング
    this.categoriesValue.filter(c => c[2] == parentId).forEach(c => {
      select.add(new Option(c[1], c[0]))
    })

    if (childCategory) {
      childCategory.replaceWith(select)
    } else {
      this.childContainerTarget.appendChild(select)
    }

    this.toggleButton(true)
  }

  toggleButton(isEnabled) {
    const btn = this.submitButtonTarget
    btn.disabled = !isEnabled
    if (isEnabled) {
      btn.classList.replace('bg-gray-400', 'bg-blue-600')
    } else {
      btn.classList.replace('bg-blue-600', 'bg-gray-400')
    }
  }
}
