# typed: false
require "rails_helper"

RSpec.describe Ui::Form::TextAreaComponent, type: :component do
  let(:user) { User.new }
  let(:form_builder) do
    ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
  end

  it "renders a textarea element" do
    render_inline(described_class.new(form: form_builder, field: :introduction))
    expect(page).to have_css('textarea')
  end

  it "sets the name attribute correctly" do
    render_inline(described_class.new(form: form_builder, field: :introduction))
    expect(page).to have_css('textarea[name="user[introduction]"]')
  end

  it "sets the default rows attribute" do
    render_inline(described_class.new(form: form_builder, field: :introduction))
    expect(page).to have_css('textarea[rows="4"]')
  end

  it "accepts custom rows parameter" do
    render_inline(described_class.new(form: form_builder, field: :introduction, rows: 10))
    expect(page).to have_css('textarea[rows="10"]')
  end

  it "applies base styling classes" do
    render_inline(described_class.new(form: form_builder, field: :introduction))
    expect(page).to have_css('.w-full.bg-brand-50\/50')
  end

  it "accepts placeholder parameter" do
    render_inline(described_class.new(form: form_builder, field: :introduction, placeholder: "Tell us about yourself"))
    expect(page).to have_css('textarea[placeholder="Tell us about yourself"]')
  end

  it "accepts custom class names" do
    render_inline(described_class.new(form: form_builder, field: :introduction, class_names: "custom-class"))
    expect(page).to have_css('.custom-class')
  end

  it "works with different field types" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('textarea[name="user[name]"]')
  end
end
