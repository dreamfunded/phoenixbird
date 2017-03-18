App.concerns.Editable = ComposedComponent => class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_editing: null
    }
    this.beforeAction = this.beforeAction.bind(this);
    this.toggleEdit = this.toggleEdit.bind(this);
    this.cancelEdit = this.cancelEdit.bind(this);
  }

  beforeAction(e, callback) {
    e.preventDefault();
    callback.call(this, e)
  }

  cancelEdit(e) {
    this.beforeAction(e, function() {
      this.setState({is_editing: false})
    })
  }

  toggleEdit(e) {
    this.beforeAction(e, function() {
      this.setState({is_editing: true})
    })
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ is_editing: nextProps.new_item })
  }

  render() {
    return (
      <ComposedComponent
        cancelEdit={this.cancelEdit}
        toggleEdit={this.toggleEdit}
        {...this.props}
        {...this.state} />
      )
  }
}