require 'spec_helper'

describe Announcement, :type => :model do
  it {is_expected.to respond_to :text}
  it {is_expected.to respond_to :text=}
  it {is_expected.to respond_to :show_until}
  it {is_expected.to respond_to :show_until=}
  it {is_expected.to respond_to :active?}
  it {is_expected.to respond_to :active=}

  describe "class methods" do
    before :each do

    end

    describe '#only_one' do
      before :each do

      end

      context "WHEN no announcement exists" do
        before :each do

        end

        it {expect(Announcement.only_one.text).to eql "Announcement"}
        it {expect(Announcement.only_one.show_until).to eql(Date.today + 14.days)}
        it {expect(Announcement.only_one.active).to eql false}

      end

      context "WHEN an announcement exists" do
        before :each do
          @announcement = FactoryGirl.create(:announcement)
        end

        it{expect(Announcement.only_one).to eql @announcement}
      end
    end

    describe '#active_and_current' do
      describe "WHEN no announcement is active" do
        before :each do
          FactoryGirl.create(:inactive_announcement)
        end

        it{ expect(Announcement.active_and_current).to be_nil }
      end

      describe "WHEN the one announcement is active and today is before show_until" do
        before :each do
          @announcement = FactoryGirl.create(:active_announcement,
                                         :show_until => Date.today + 14.days)
        end

        it{ expect(Announcement.active_and_current).to eql @announcement }
      end

      describe "WHEN the one announcement is active and today is after show_until" do
        before :each do
          FactoryGirl.create(:active_announcement,
                         :show_until => Date.today - 14.days)
        end

        it{ expect(Announcement.active_and_current).to be_nil }
      end

      describe "WHEN the one announcement is active and today equals show_until" do
        before :each do
          @announcement = FactoryGirl.create(:active_announcement,
                                         :show_until => Date.today)
        end

        it{ expect(Announcement.active_and_current).to eql @announcement }
      end
    end

    describe "instance methods" do
      describe '#active_and_current?' do
        describe "WHEN the announcement is not active" do
          before :each do
            @announcement = FactoryGirl.build(:inactive_announcement)
          end

          it{ expect(@announcement.active_and_current?).to be_falsey }
        end

        describe "WHEN the announcement is active and today is before show_until" do
          before :each do
            @announcement = FactoryGirl.build(:active_announcement,
                                           :show_until => Date.today + 14.days)
          end

          it{ expect(@announcement.active_and_current?).to be_truthy }
        end

        describe "WHEN the announcement is active and today is after show_until" do
          before :each do
            @announcement = FactoryGirl.build(:active_announcement,
                           :show_until => Date.today - 14.days)
          end

          it{ expect(@announcement.active_and_current?).to be_falsey }
        end

        describe "WHEN the announcement is active and today equals show_until" do
          before :each do
            @announcement = FactoryGirl.build(:active_announcement,
                                           :show_until => Date.today)
          end

          it{ expect(@announcement.active_and_current?).to be_truthy }
        end
      end


    end
  end
end
