class MakeEventIdOptionalOnLapResults < ActiveRecord::Migration[7.0]
  def change
    change_column_null :lap_results, :event_id, true
  end
end
