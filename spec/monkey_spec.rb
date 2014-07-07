require 'rails_helper'

describe Time do
  describe 'Time#next_where' do
    it "should give the next minute when forward 50 seconds" do
      t1 = Time.new(2014, 7, 6, 23, 45, 12)
      t2 = t1.advance(seconds: 50)
      expect(t1.next_where(sec: 2)).to eql(t2)
    end

    it "should give the next hour when forward 20 minutes" do
      t1 = Time.new(2014, 7, 6, 23, 45, 20)
      t2 = t1.advance(minutes: 20).change(sec: 0)
      expect(t1.next_where(min: 5)).to eql(t2)
    end
    
    it "should give the next day when forward 3 hours" do
      t1 = Time.new(2014, 7, 6, 23, 45, 12)
      t2 = t1.advance(hours: 3).change(sec: 0, min: 0)
      expect(t1.next_where(hour: 2)).to eql(t2)
    end

    # it "should give the 2nd of July when forward to tuesday" do
    #   t1 = Time.new(2014, 7, 25, 23, 45, 12)
    #   t2 = t1.advance(days: 7)
    #   expect(t1.next_where(wday: 2)).to eql(t2)
    # end

    it "should give the next month when forward 6 days" do
      t1 = Time.new(2014, 7, 25, 23, 45, 12)
      t2 = t1.advance(days: 7).change(sec: 0, min: 0, hour: 0)
      expect(t1.next_where(day: 1)).to eql(t2)
    end

    it "should give the next year when forward 6 months" do
      t1 = Time.new(2014, 7, 25, 23, 45, 12)
      t2 = t1.advance(months: 6).change(sec: 0, min: 0, hour: 0, day: 1)
      expect(t1.next_where(month: 1)).to eql(t2)
    end
  end
end
