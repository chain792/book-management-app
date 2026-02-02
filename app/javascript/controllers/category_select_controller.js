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
    select.classList.add('w-full', 'bg-brand-50/50', 'border-2', 'border-brand-100', 'rounded-2xl', 'px-6', 'py-4', 'font-bold', 'text-brand-900', 'focus:bg-white', 'focus:border-brand-500', 'focus:ring-4', 'focus:ring-brand-100', 'focus:outline-none', 'transition-all', 'cursor-pointer', 'appearance-none')

    select.add(new Option('小カテゴリを選択', ''))

    // データのフィルタリング
    this.categoriesValue.filter(c => c[2] == parentId).forEach(c => {
      select.add(new Option(c[1], c[0]))
    })

    if (childCategory) {
      childCategory.replaceWith(select)
    } else {
      // ラッパーを作成して矢印を追加（簡易版）
      const wrapper = document.createElement("div")
      wrapper.classList.add("relative", "space-y-3")
      wrapper.id = "child_category_wrapper"

      const label = document.createElement("label")
      label.classList.add("text-xs", "font-black", "text-brand-400", "uppercase", "tracking-widest", "pl-1")
      label.textContent = "詳細カテゴリー"

      const innerWrapper = document.createElement("div")
      innerWrapper.classList.add("relative")
      innerWrapper.appendChild(select)

      const arrow = document.createElement("div")
      arrow.classList.add("absolute", "inset-y-0", "right-4", "flex", "items-center", "pointer-events-none", "text-brand-400")
      arrow.innerHTML = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>'
      innerWrapper.appendChild(arrow)

      wrapper.appendChild(label)
      wrapper.appendChild(innerWrapper)
      this.childContainerTarget.appendChild(wrapper)
    }

    this.toggleButton(true)
  }

  toggleButton(isEnabled) {
    const btn = this.submitButtonTarget
    btn.disabled = !isEnabled
    if (isEnabled) {
      btn.classList.remove('bg-brand-200', 'cursor-not-allowed')
      btn.classList.add('bg-brand-900', 'cursor-pointer')
    } else {
      btn.classList.add('bg-brand-200', 'cursor-not-allowed')
      btn.classList.remove('bg-brand-900', 'cursor-pointer')
    }
  }
}
