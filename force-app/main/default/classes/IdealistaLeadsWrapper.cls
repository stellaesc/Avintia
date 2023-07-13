global class IdealistaLeadsWrapper {

	public String customerCode;
	public List<CustomerProperties> customerProperties;

	public class CustomerProperties {
		public String propertyId;
		public String propertyOperation;
		public transient String propertyCode;
		public List<PropertyLeads> propertyLeads;
		public String propertyReference;
	}

	public class PropertyLeads {
		public String leadType;
		public String leadContactName;
		public String leadContactEmail;
		public String leadContactPhone;
		public String leadDate;
		public String leadMessage;
	}

	
	public static IdealistaLeadsWrapper parse(String json) {
		return (IdealistaLeadsWrapper) System.JSON.deserialize(json, IdealistaLeadsWrapper.class);
	}
}