# typed: false
require "rails_helper"

RSpec.describe Ui::Form::SelectComponent, type: :component do
  let(:user) { User.new }
  let(:form_builder) do
    ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
  end
  let(:choices) { [["Option 1", "1"], ["Option 2", "2"], ["Option 3", "3"]] }

  it "renders a select element" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices))
    expect(page).to have_css('select')
  end

  it "sets the name attribute correctly" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices))
    expect(page).to have_css('select[name="user[role]"]')
  end

  it "displays all options" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices))
    expect(page).to have_css('option', count: 3)
    expect(page).to have_text("Option 1")
    expect(page).to have_text("Option 2")
    expect(page).to have_text("Option 3")
  end

  it "sets option values correctly" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices))
    expect(page).to have_css('option[value="1"]')
    expect(page).to have_css('option[value="2"]')
    expect(page).to have_css('option[value="3"]')
  end

  it "applies base styling classes" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices))
    expect(page).to have_css('.w-full.bg-brand-50\/50')
  end

  it "renders the dropdown arrow icon" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices))
    expect(page).to have_css('svg')
  end

  it "accepts options parameter" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices, options: { include_blank: "Select one" }))
    expect(page).to have_text("Select one")
  end

  it "accepts custom HTML options" do
    render_inline(described_class.new(form: form_builder, field: :role, choices: choices, class: "custom-class"))
    expect(page).to have_css('.custom-class')
  end
end
