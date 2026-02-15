# typed: false
require "rails_helper"

RSpec.describe Ui::ButtonComponent, type: :component do
  context "with primary variant" do
    it "applies the correct CSS classes" do
      render_inline(described_class.new(variant: "primary")) { "Click me" }
      expect(page).to have_css('.btn-primary')
    end
  end

  context "with secondary variant" do
    it "applies the correct CSS classes" do
      render_inline(described_class.new(variant: "secondary")) { "Click me" }
      expect(page).to have_css('.btn-secondary')
    end
  end

  context "with danger variant" do
    it "applies the correct CSS classes" do
      render_inline(described_class.new(variant: "danger")) { "Delete" }
      expect(page).to have_css('.bg-rose-500')
    end
  end

  context "with size parameter" do
    it "applies small size classes" do
      render_inline(described_class.new(size: "sm")) { "Small" }
      expect(page).to have_css('.px-4.py-2.text-xs')
    end

    it "applies large size classes" do
      render_inline(described_class.new(size: "lg")) { "Large" }
      expect(page).to have_css('.px-10.py-4.text-base')
    end
  end

  it "renders the block content" do
    render_inline(described_class.new) { "Button Text" }
    expect(page).to have_text("Button Text")
  end

  it "has the correct button type by default" do
    render_inline(described_class.new) { "Click" }
    expect(page).to have_css('button[type="button"]')
  end

  it "accepts custom type parameter" do
    render_inline(described_class.new(type: "submit")) { "Submit" }
    expect(page).to have_css('button[type="submit"]')
  end

  it "applies custom class names" do
    render_inline(described_class.new(class_names: "custom-class")) { "Custom" }
    expect(page).to have_css('.custom-class')
  end

  it "accepts additional HTML options" do
    render_inline(described_class.new(onclick: "alert('clicked')")) { "Alert" }
    expect(page).to have_css('button[onclick="alert(\'clicked\')"]')
  end
end
