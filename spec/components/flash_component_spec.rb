# typed: false
require "rails_helper"

RSpec.describe FlashComponent, type: :component do
  let(:flash) { ActionDispatch::Flash::FlashHash.new }

  context "when flash has success message" do
    it "displays success message" do
      flash[:notice] = "Success message"
      render_inline(described_class.new(flash: flash))
      expect(page).to have_text("Success message")
    end
  end

  context "when flash has danger message" do
    it "displays danger message" do
      flash[:alert] = "Danger message"
      render_inline(described_class.new(flash: flash))
      expect(page).to have_text("Danger message")
    end
  end

  context "when flash has info message" do
    it "displays info message" do
      flash[:info] = "Info message"
      render_inline(described_class.new(flash: flash))
      expect(page).to have_text("Info message")
    end
  end

  context "when flash is empty" do
    it "renders nothing" do
      render_inline(described_class.new(flash: flash))
      expect(page).not_to have_css(".glass")
    end
  end

  context "when flash has multiple messages" do
    it "displays all messages" do
      flash[:notice] = "Success message"
      flash[:alert] = "Error message"
      render_inline(described_class.new(flash: flash))
      expect(page).to have_text("Success message")
      expect(page).to have_text("Error message")
    end
  end
end
