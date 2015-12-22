require 'rails_helper'

RSpec.describe AttachedDocument, type: :model do
  it { should belong_to(:followup) }

  describe "validate creation of new attached_documents" do
    let(:user) { FactoryGirl.create(:user) }

    let(:cashout) { user.lines.create!(name: 'Cashouts', properties: [{name: 'Campaign', required: true},
               {name: 'Influencer', required: false}]) }

    let(:entry) { cashout.line_entries.create(user: user, data: {campaign: "Nickelodeon"}) }

    let (:followup) { Followup.create!(line_entry: entry , user: user, description: "Esta es una linda prueba", percentage: 2) }

    context "should validate followup_id and document" do
      it "shouldn't create and attached_document" do
        document = AttachedDocument.new
        document.followup_id = followup.id

        expect(AttachedDocument.count).to eq 0
        expect(document.save).to eq false
        expect(AttachedDocument.count).to eq 0
      end

      it "shouldn't create and attached_document" do
        document = AttachedDocument.new
        File.open(File.join("#{Rails.root}/image.jpg"), 'r') do |file|
          document.document = file
        end

        expect(AttachedDocument.count).to eq 0
        expect(document.save).to eq false
        expect(AttachedDocument.count).to eq 0
      end

      it "should create and attached_document" do
        document = AttachedDocument.new
        File.open(File.join("#{Rails.root}/image.jpg"), 'r') do |file|
          document.document = file
        end
        document.followup_id = followup.id

        expect(AttachedDocument.count).to eq 0
        expect(document.save).to eq true
        expect(AttachedDocument.count).to eq 1
      end

      it "should return the attachment url" do
        document = AttachedDocument.new
        File.open(File.join("#{Rails.root}/image.jpg"), 'r') do |file|
          document.document = file
        end
        document.followup_id = followup.id
        document.save

        expect(document.document.url).to eq "/uploads/attached_document/document/#{document.id}/image.jpg"
      end
    end
  end
end
