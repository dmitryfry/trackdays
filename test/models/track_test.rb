require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "validates inclusion of source_key in SOURCE_KEYS" do
    track = Track.new(name: "Valid Track", source_key: "igora")
    assert track.valid?

    invalid_track = Track.new(name: "Invalid Track", source_key: "unknown_autodrome")
    assert_not invalid_track.valid?
    assert_includes invalid_track.errors[:source_key], "is not included in the list"
  end

  test "validates uniqueness of source_key" do
    Track.create!(name: "MRV 1", source_key: "mrv")
    duplicate = Track.new(name: "MRV 2", source_key: "mrv")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:source_key], "has already been taken"
  end

  test "allows nil source_key" do
    track1 = Track.create!(name: "Manual 1", source_key: nil)
    track2 = Track.new(name: "Manual 2", source_key: nil)

    assert track1.valid?
    assert track2.valid?
  end
end
