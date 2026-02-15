# typed: false
require "rails_helper"

RSpec.describe Ui::Form::LabelComponent, type: :component do
  let(:user) { User.new }
  let(:form_builder) do
    ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
  end

  it "renders a label element" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('label')
  end

  it "sets the for attribute correctly" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('label[for="user_name"]')
  end

  it "displays the default label text" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css("label")
  end

  it "accepts custom label text" do
    render_inline(described_class.new(form: form_builder, field: :name, text: "Full Name"))
    expect(page).to have_text("Full Name")
  end

  it "applies base styling classes" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('.text-xs.font-black.text-brand-400')
  end

  it "accepts custom class names" do
    render_inline(described_class.new(form: form_builder, field: :name, class_names: "custom-class"))
    expect(page).to have_css('.custom-class')
  end

  it "works with different field types" do
    render_inline(described_class.new(form: form_builder, field: :email))
    expect(page).to have_css('label[for="user_email"]')
  end
end
