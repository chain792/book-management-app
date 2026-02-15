# typed: false
require "rails_helper"

RSpec.describe Ui::Form::InputComponent, type: :component do
  let(:user) { User.new }
  let(:form_builder) do
    ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
  end

  it "renders an input element" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('input')
  end

  it "sets the name attribute correctly" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('input[name="user[name]"]')
  end

  context "with text type" do
    it "renders a text input" do
      render_inline(described_class.new(form: form_builder, field: :name, type: "text"))
      expect(page).to have_css('input[type="text"]')
    end
  end

  context "with email type" do
    it "renders an email input" do
      render_inline(described_class.new(form: form_builder, field: :email, type: "email"))
      expect(page).to have_css('input[type="email"]')
    end
  end

  context "with password type" do
    it "renders a password input" do
      render_inline(described_class.new(form: form_builder, field: :password, type: "password"))
      expect(page).to have_css('input[type="password"]')
    end
  end

  context "with number type" do
    it "renders a number input" do
      render_inline(described_class.new(form: form_builder, field: :name, type: "number"))
      expect(page).to have_css('input[type="number"]')
    end
  end

  context "with search type" do
    it "renders a search input" do
      render_inline(described_class.new(form: form_builder, field: :name, type: "search"))
      expect(page).to have_css('input[type="search"]')
    end
  end

  it "applies base styling classes" do
    render_inline(described_class.new(form: form_builder, field: :name))
    expect(page).to have_css('.w-full.bg-brand-50\/50')
  end

  it "accepts placeholder parameter" do
    render_inline(described_class.new(form: form_builder, field: :name, placeholder: "Enter your name"))
    expect(page).to have_css('input[placeholder="Enter your name"]')
  end

  it "accepts custom class names" do
    render_inline(described_class.new(form: form_builder, field: :name, class_names: "custom-class"))
    expect(page).to have_css('.custom-class')
  end
end
