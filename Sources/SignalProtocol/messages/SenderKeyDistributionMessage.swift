import SignalFfi

class SenderKeyDistributionMessage {
    private var handle: OpaquePointer?

    deinit {
        signal_sender_key_distribution_message_destroy(handle)
    }

    internal var nativeHandle: OpaquePointer? {
        return handle
    }

    init(name: SenderKeyName, store: SenderKeyStore, context: UnsafeMutableRawPointer?) throws {
        try withSenderKeyStore(store) {
            try checkError(signal_create_sender_key_distribution_message(&handle, name.nativeHandle,
                                                                         $0, context))
        }
    }

    init(keyId: UInt32,
         iteration: UInt32,
         chainKey: [UInt8],
         publicKey: PublicKey) throws {

        try checkError(signal_sender_key_distribution_message_new(&handle,
                                                                  keyId,
                                                                  iteration,
                                                                  chainKey,
                                                                  chainKey.count,
                                                                  publicKey.nativeHandle))
    }

    init(bytes: [UInt8]) throws {
        try checkError(signal_sender_key_distribution_message_deserialize(&handle, bytes, bytes.count))
    }

    func signatureKey() throws -> PublicKey {
        return try invokeFnReturningPublicKey {
            signal_sender_key_distribution_message_get_signature_key($0, handle)
        }
    }

    func id() throws -> UInt32 {
        return try invokeFnReturningInteger {
            signal_sender_key_distribution_message_get_id(handle, $0)
        }
    }

    func iteration() throws -> UInt32 {
        return try invokeFnReturningInteger {
            signal_sender_key_distribution_message_get_iteration(handle, $0)
        }
    }

    func serialize() throws -> [UInt8] {
        return try invokeFnReturningArray {
            signal_sender_key_distribution_message_serialize(handle, $0, $1)
        }
    }

    func chainKey() throws -> [UInt8] {
        return try invokeFnReturningArray {
            signal_sender_key_distribution_message_get_chain_key(handle, $0, $1)
        }
    }
}
