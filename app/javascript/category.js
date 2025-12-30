function showChildCategory(){
  const target = this.event.target
  const select = document.createElement("select")
  const button = document.getElementById('submit-button')

  // 大カテゴリを選択を選んだ場合は小カテゴリのセレクト要素を削除し、ボタンを無効化する
  if(!target.value){
    childCategory = document.getElementById('child_category')
    if(childCategory){
      childCategory.remove()
    }
    button.disabled = true
    button.classList.remove('btn-primary')
    button.classList.add('btn-secondary')
    return
  }

  // 子カテゴリのセレクト要素を作成
  select.add(new Option('小カテゴリを選択', ''))
  gon.categories.filter(category => category[2] == target.value).forEach(category => {
    const option = new Option(category[1], category[0])
    select.add(option)
  })
  select.id = 'child_category'
  select.classList.add('form-select')
  select.name = 'book[child_category]'

  childCategory = document.getElementById('child_category')
  if(childCategory){
    // 子カテゴリが既に存在する場合は置き換える
    childCategory.replaceWith(select)
  }else{
    // 子カテゴリが存在しない場合は新規に追加する
    document.getElementById('category-select-form').appendChild(select)
  }
  // ボタンを有効化する
  button.disabled = false
  button.classList.remove('btn-secondary')
  button.classList.add('btn-primary')
}

document.addEventListener('turbolinks:load', () => {
  const parentCategory = document.getElementById("parent_category")
  if(parentCategory){
    parentCategory.addEventListener("change", () => { showChildCategory() })
  }
})