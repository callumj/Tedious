class Review < ActiveRecord::Base

  LOCK_TIME_FRAME = 5.minutes

  def self.pending_scope
    not_locked.not_processed.order("id ASC")
  end

  def self.not_processed
    where(processed: false)
  end

  def self.not_locked
    where(arel_table[:locked_until].eq(nil).or(arel_table[:locked_until].lt(Time.now.utc)))
  end

  def self.accepted
    where(arel_table[:accepts].gt(0)).where(arel_table[:rejects].eq(0))
  end

  def self.rejected
    where(arel_table[:rejects].gt(0)).where(arel_table[:accepts].eq(0))
  end

  def lock!
    set_lock! Time.now + LOCK_TIME_FRAME
  end

  def accept!
    apply_operation :accepts
  end

  def reject!
    apply_operation :rejects
  end

  private

    def apply_operation(mode)
      updates = {updated_at: Time.now.utc, processed: true}
      updates[mode] = (self.send(mode) + 1)

      updates.each { |key, value| write_attribute(key, value) }

      self.class.update_all(updates, id: self.id)
      set_lock! nil
    end

    def set_lock!(time)
      self.class.update_all({locked_until: time.try(:utc), updated_at: Time.now.utc}, id: self.id)
      self.locked_until = time
    end
end
