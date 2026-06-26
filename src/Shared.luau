local client = script.Parent.CheckoutClient

local remote = Instance.new("RemoteEvent")
remote.Parent = client

return {
    Client = client,
    Remote = remote,
}

