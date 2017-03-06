class Panel extends React.Component {
  render() {
    let {title, children} = this.props;
    return (
      <div className='panel panel-default'>
        <div className='panel-heading'>{title}</div>
        <div>{children}</div>
      </div>
      )
  }
}

class PanelBody extends React.Component {
  render() {
    return (
      <div className='panel-body'>
        {this.props.children}
      </div>
      )
  }
}