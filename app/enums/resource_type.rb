class ResourceType < ClassyEnum::Base
end

class ResourceType::Product < ResourceType
end

class ResourceType::Feature < ResourceType
end

class ResourceType::Comment < ResourceType
end

class ResourceType::User < ResourceType
end
