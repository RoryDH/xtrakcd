require 'rails_helper'

describe Time do
  describe 'Time#next_where' do
    before do
      @t1 = Time.new(2014, 7, 25, 22, 45, 12)
    end

    it "should give the next minute when going to next 2 seconds" do
      t2 = Time.new(2014, 7, 25, 22, 46, 02)
      expect(@t1.next_where(sec: 2)).to eql(t2)
    end

    it "should give the next hour when going to next 5 minutes" do
      t2 = Time.new(2014, 7, 25, 23, 5, 0)
      expect(@t1.next_where(min: 5)).to eql(t2)
    end
    
    it "should give the next day when going to next 2am" do
      t2 = Time.new(2014, 7, 26, 2, 0, 0)
      expect(@t1.next_where(hour: 2)).to eql(t2)
    end

    it "should give the 26th of July when forward to saturday" do
      t2 = Time.new(2014, 7, 26, 0, 0, 0)
      expect(@t1.next_where(wday: 6)).to eql(t2)
    end

    it "should give the 29th of July when forward to tuesday" do
      t2 = Time.new(2014, 7, 29, 0, 0, 0)
      expect(@t1.next_where(wday: 2)).to eql(t2)
    end

    it "should give the next month when going to next monday" do
      t2 = Time.new(2014, 8, 1, 0, 0, 0)
      expect(@t1.next_where(day: 1)).to eql(t2)
    end

    it "should give the next year when going to next january" do
      t2 = Time.new(2015, 1, 1, 0, 0, 0)
      expect(@t1.next_where(month: 1)).to eql(t2)
    end

    it "should be able to handle a mixture of month, hour, sec" do
      t2 = Time.new(2015, 3, 8, 15, 0, 2)
      expect(@t1.next_where(month: 3, day: 8, hour: 15, sec: 2)).to eql(t2)
    end

    it "should be able to handle a mixture of month, wday" do
      t2 = Time.new(2014, 12, 3, 0, 0, 0)
      expect(@t1.next_where(month: 12, wday: 3)).to eql(t2)
    end
  end
end
