# typed: false
require "rails_helper"

RSpec.describe Layout::FooterComponent, type: :component do
  it "displays the copyright text" do
    render_inline(described_class.new)
    expect(page).to have_text("Designed for the developer community")
  end

  it "displays the current year" do
    render_inline(described_class.new)
    current_year = Time.zone.now.year
    expect(page).to have_text(current_year.to_s)
  end

  it "displays the branding" do
    render_inline(described_class.new)
    expect(page).to have_text("Engineer Book Reviews")
  end

  it "displays the terms link" do
    render_inline(described_class.new)
    expect(page).to have_text("利用規約")
    expect(page).to have_css("a[href*='terms']")
  end

  it "displays the privacy link" do
    render_inline(described_class.new)
    expect(page).to have_text("プライバシー")
    expect(page).to have_css("a[href*='privacy']")
  end

  it "displays the contact link" do
    render_inline(described_class.new)
    expect(page).to have_text("お問い合わせ")
    expect(page).to have_css("a[href*='google.com']")
  end

  it "has the correct footer structure" do
    render_inline(described_class.new)
    expect(page).to have_css("footer")
  end
end
