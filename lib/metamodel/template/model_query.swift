// MARK: - Query

public extension <%= model.name %> {
    static var all: <%= model.relation_name %> {
        get { return <%= model.relation_name %>() }
    }

    static var first: <%= model.name %>? {
        get {
            return <%= model.relation_name %>().orderBy(.privateId, asc: true).first
        }
    }

    static var last: <%= model.name %>? {
        get {
            return <%= model.relation_name %>().orderBy(.privateId, asc: false).first
        }
    }

    static func first(length: UInt) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().orderBy(.privateId, asc: true).limit(length)
    }

    static func last(length: UInt) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().orderBy(.privateId, asc: false).limit(length)
    }

    static func find(id: Int) -> <%= model.name %>? {
        return <%= model.relation_name %>().find(id).first
    }

    static func findBy(<%= model.property_key_type_pairs(true, true) %>) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().findBy(<%= model.property_key_value_pairs %>)
    }

    static func filter(<%= model.property_key_type_pairs(true, true) %>) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().filter(<%= model.property_key_value_pairs %>)
    }

    static func limit(length: UInt, offset: UInt = 0) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().limit(length, offset: offset)
    }

    static func take(length: UInt) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().limit(length)
    }

    static func offset(offset: UInt) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().offset(offset)
    }

    static func groupBy(columns: <%= model.name %>.Column...) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().groupBy(columns)
    }

    static func groupBy(columns: [<%= model.name %>.Column]) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().groupBy(columns)
    }

    static func orderBy(column: <%= model.name %>.Column) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().orderBy(column)
    }

    static func orderBy(column: <%= model.name %>.Column, asc: Bool) -> <%= model.relation_name %> {
        return <%= model.relation_name %>().orderBy(column, asc: asc)
    }
}

public extension <%= model.relation_name %> {
    func findBy(<%= model.property_key_type_pairs(true, true) %>) -> Self {
        var attributes: [<%= model.name %>.Column: Any] = [:]
        <% model.properties.each do |property| %><%= "if (#{property.name} != #{property.type_without_optional}DefaultValue) { attributes[.#{property.name}] = #{property.name} }" %>
        <% end %>return self.filter(attributes)
    }

    func filter(<%= model.property_key_type_pairs(true, true) %>) -> Self {
        return findBy(<%= model.property_key_value_pairs %>)
    }

    func filter(conditions: [<%= model.name %>.Column: Any]) -> Self {
        for (column, value) in conditions {
            let columnSQL = "\(expandColumn(column))"

            func filterByEqual(value: Any) {
                self.filter.append("\(columnSQL) = \(value)")
            }

            func filterByIn(value: [String]) {
                self.filter.append("\(columnSQL) IN (\(value.joinWithSeparator(", ")))")
            }

            if let value = value as? String {
                filterByEqual(value.unwrapped)
            } else if let value = value as? Int {
                filterByEqual(value)
            } else if let value = value as? Double {
                filterByEqual(value)
            } else if let value = value as? [String] {
                filterByIn(value.map { $0.unwrapped })
            } else if let value = value as? [Int] {
                filterByIn(value.map { $0.description })
            } else if let value = value as? [Double] {
                filterByIn(value.map { $0.description })
            } else {
                let valueMirror = Mirror(reflecting: value)
                print("!!!: UNSUPPORTED TYPE \(valueMirror.subjectType)")
            }

        }
        return self
    }

    func groupBy(columns: <%= model.name %>.Column...) -> Self {
        return self.groupBy(columns)
    }

    func groupBy(columns: [<%= model.name %>.Column]) -> Self {
        func groupBy(column: <%= model.name %>.Column) {
            self.group.append("\(expandColumn(column))")
        }
        _ = columns.flatMap(groupBy)
        return self
    }

    func orderBy(column: <%= model.name %>.Column) -> Self {
        self.order.append("\(expandColumn(column))")
        return self
    }

    func orderBy(column: <%= model.name %>.Column, asc: Bool) -> Self {
        self.order.append("\(expandColumn(column)) \(asc ? "ASC".unwrapped : "DESC".unwrapped)")
        return self
    }
}
