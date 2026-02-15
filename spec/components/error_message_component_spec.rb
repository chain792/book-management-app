# typed: false
require "rails_helper"

RSpec.describe ErrorMessageComponent, type: :component do
  let(:user) { User.new(name: "", email: "invalid") }

  context "when object has errors" do
    before do
      user.valid?
    end

    it "displays error messages" do
      render_inline(described_class.new(object: user))
      expect(page).to have_css("#error-message")
    end

    it "renders the component" do
      component = described_class.new(object: user)
      expect(component.render?).to be true
    end

    it "displays error messages in a list" do
      render_inline(described_class.new(object: user))
      expect(page).to have_css("ul.list-disc")
      expect(page).to have_css("li")
    end
  end

  context "when object has no errors" do
    let(:valid_user) { create(:user) }

    it "does not render the component" do
      component = described_class.new(object: valid_user)
      expect(component.render?).to be false
    end

    it "renders nothing" do
      result = render_inline(described_class.new(object: valid_user))
      expect(result.to_html.strip).to be_empty
    end
  end
end
