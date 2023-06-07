class DeviceSerializer < ActiveModel::Serializer
    attributes :device_id

    has_many :assigned_experiments
end